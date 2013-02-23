# encoding: UTF-8

namespace :images do

  # assumed folder structure:
  # - galleries (not checked into code repository)
  #   - berlin
  #   - london
  #   - tokyo
  # - repo (code repository from which the rake task is run)

  desc 'Scan local public/files folder for images, find the corresponding Image objects in the DB (by their SHA256) and update their local_path attributes'
  task scan_filenames: :environment do
    base_path = Rails.root.join('public', 'files')

    client = Dropbox::API::Client.new(token: Settings.dropbox.token, secret: Settings.dropbox.secret)
    base_path = Dir.pwd.sub(/\/[^\/]+(\/)*$/, '/galleries')
    gallery_folders = Dir["#{base_path}/*"].map{|e| e.split('/').last}

    gallery_folders.each do |gallery_folder|
      gallery = Gallery.find_or_create_by_title(gallery_folder.capitalize)
      Dir["#{base_path}/#{gallery_folder}/*"].each do |image_path|
        file = File.new(image_path)

        image_file_name = File.basename(file.path) # .basename gives us just "my_image.jpg" from, e.g., "~/photos/my_image.jpg" 
        image = Image.create uuid:         Digest::SHA256.hexdigest(file),
                             file_name:    image_file_name,
                             gallery_name: gallery_folder,
                             width:        Dimensions.width(file),
                             height:       Dimensions.height(file),
                             url:          "http://dl.dropbox.com/u/3374145/#{gallery_folder}/#{image_file_name}",
                             local_path:   file.path
        gallery.images << image

        puts "Image #{image_path} not valid: #{image.errors.inspect}" unless image.valid?

        client.upload "Public/#{gallery_folder}/#{image_file_name}", file.read

      end
    end
  end

  # TODO: adjust to new model structure - use Gallery instead of Location
  desc 'Query Dropbox API for image paths & store them in the database.'
  task :sync_down => :environment do
    client = Dropbox::API::Client.new(:token => Settings.dropbox.token, :secret => Settings.dropbox.secret)

    client.ls('Public').each do |gallery_folder|
      folder_name = gallery_folder.path.split('/').last
      #location = Location.find_or_create_by_country(:country => folder_name)

      gallery_folder.ls.each do |image|
        puts image.path.split('/').last
        Image.create :url => "http://dl.dropbox.com/u/3374145/#{folder_name}/#{image.path.split('/').last}"
      end
    end
  end

end

