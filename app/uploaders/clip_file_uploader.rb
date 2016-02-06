class ClipFileUploader < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay
  before :cache, :save_duration
  before :cache, :save_original_filename

  process encode_audio: [:ogg]
  process encode_audio: [:m4a, false]

  def save_duration(file)
    file = ::FFMPEG::Movie.new(file.path)
    model.duration = file.duration
  end

  def save_original_filename(file)
    model.original_filename ||= file.original_filename if file.respond_to?(:original_filename)
  end

  # Override the directory where uploaded files will be stored.
  def store_dir
    env = Rails.env.staging? ? 'production' : Rails.env
    "#{env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.uuid}"
  end

  def fog_directory
    'public_audio'
  end

  def fog_public
    true
  end

  def asset_host
    Rails.application.secrets.rackspace_audio_asset_host
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    Song::ACCEPTED_CLIP_FORMATS
  end

  def filename
    "#{secure_token(32)}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token(length=16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end

  def encode_audio(format='ogg', overwrite=true)
    directory = File.dirname(current_path)
    tmpfile = File.join(directory, 'tmpfile')
    if overwrite
      FileUtils.mv(current_path, tmpfile)
    else
      FileUtils.cp(current_path, tmpfile)
    end

    file = ::FFMPEG::Movie.new(tmpfile)
    new_name = File.basename(current_path, '.*') + '.' + format.to_s
    current_extension = File.extname(current_path).gsub('.', '')
    encoded_file = File.join(directory, new_name)

    file.transcode(encoded_file){ |progress| puts progress }

    if overwrite
      self.filename[-current_extension.size..-1] = format.to_s
      self.file.file[-current_extension.size..-1] = format.to_s
      File.delete(tmpfile)
    else
      self.model.file_aac = File.open(encoded_file)
    end

  end
end
