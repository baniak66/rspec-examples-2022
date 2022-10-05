require "shrine"
require "shrine/storage/file_system"
require "cloudinary"
require "shrine/storage/cloudinary"
require "shrine/storage/memory"

Cloudinary.config(
  cloud_name: ENV["CLOUDINARY_CLOUD_NAME"],
  api_key:    ENV["CLOUDINARY_API_KEY"],
  api_secret: ENV["CLOUDINARY_API_SECRET"],
)
if Rails.env.test?
  Shrine.storages = {
    cache: Shrine::Storage::Memory.new,
    store: Shrine::Storage::Memory.new,
  }
elsif Rails.env.development?
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads"),       # permanent
  }
else
  Shrine.storages = {
    cache: Shrine::Storage::Cloudinary.new(prefix: "cache"), # for direct uploads
    store: Shrine::Storage::Cloudinary.new,
  }
end

Shrine.plugin :activerecord           # loads Active Record integration
Shrine.plugin :cached_attachment_data # enables retaining cached file across form redisplays
Shrine.plugin :restore_cached_data    # extracts metadata for assigned cached files
