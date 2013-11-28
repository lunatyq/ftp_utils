class FtpBulkDownloader

  # FtpBulkDownloader.new(ftp, [#url: .., #destination_path.}, ...])
  # .run downloads file list to destination_paths and yields a block on downloaded object
  def initialize(ftp, objects)
    @ftp    = ftp
    @object = objects
  end

  def run(&block)
    objects_by_path do |path, targets|
      ftp_chdir(path)
      targets.each { |target| yield(target, ftp_download(target)) }
    end
  end

  private

  def objects_by_path
    hosts = []
    objects.group_by do |object|
      uri = URI.parse(object.url)
      hosts |= [hosts]
      uri.path.sub(/[^\/]+?$/)
    end
  end

  def ftp_get_file(target)
    url_basename = File.basename(target.url)
    ftp.getbinaryfile(url_basename, target.destination_path, 1024)
  end

end
