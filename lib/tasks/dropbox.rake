# encoding: UTF-8
# require 'dimensions'

# call with, e.g.: `rake dropbox:my_task['parameter1 parameter 2']`
namespace :dropbox do

  desc 'Query Dropbox API for image paths & store them in the database.'
  task sync_down: :environment do
    dbx_account = DropboxAccount.first
    client = Dropbox::API::Client.new(token: dbx_account.request_token, secret: dbx_account.request_secret)


    client.ls.each do |gallery_folder|
      folder_name = gallery_folder.path
      gallery = Gallery.find_or_create_by_(name: folder_name)

      gallery_folder.ls.each do |image|
        #puts image.direct_url
        #https://dl.dropboxusercontent.com/u/15321563/quack/images/bilder.001_320.jpg
        #"https://dl.dropboxusercontent.com/u/#{dbx_account.uid}/quack/images/bilder.001_320.jpg"
        Image.create url: image.direct_url
      end
    end
  end

  # assumed folder structure:
  # - galleries (not checked into code repository)
  #   - berlin
  #   - london
  #   - tokyo
  # - repo (code repository from which the rake task is run)

  # desc 'Scan local folder for images, calculate their dimensions, upload them to Dropbox and store them in the database.'
  # task :sync_up => :environment do
  #   client = Dropbox::API::Client.new(token: Settings.dropbox.token, secret: Settings.dropbox.secret)
  #   base_path = Rails.root.join('public', 'files')

  #   gallery_folders.each do |gallery_folder|
  #     gallery = Gallery.find_or_create_by_title(gallery_folder.capitalize)
  #     Dir["#{base_path}/#{gallery_folder}/*"].each do |image_path|
  #       file = File.new(image_path)

  #       image_file_name = File.basename(file.path) # .basename gives us just "my_image.jpg" from, e.g., "~/photos/my_image.jpg" 
  #       image = Image.create uuid:         Digest::SHA256.file(file).hexdigest,
  #                            file_name:    image_file_name,
  #                            gallery_name: gallery_folder,
  #                            width:        Dimensions.width(file),
  #                            height:       Dimensions.height(file),
  #                            url:          "http://dl.dropbox.com/u/3374145/#{gallery_folder}/#{image_file_name}",
  #                            local_path:   file.path
  #       gallery.images << image

  #       puts "Image #{image_path} not valid: #{image.errors.inspect}" unless image.valid?

  #       client.upload "Public/#{gallery_folder}/#{image_file_name}", file.read

  #     end
  #   end
  # end

  
end
