class FtpRecursiveLister

  def initialize(ftp)
    @ftp = ftp
  end

  def run(&block)
    if block_given?
      recursive_list(&block)
    else
      [].tap do |collection|
        recursive_list { |url| collection << url }
      end
    end
  end

  def self.run(ftp, &block)
    new(ftp).run(&block)
  end

private

  attr_reader :ftp

  def recursive_list(directory=nil, &block)
    saved_pwd   = ftp.pwd
    ftp.chdir(directory) if directory
    current_pwd = ftp.pwd

    directories = []

    ftp.list.each do |line|
      ftp_file_data = FtpLineParser.parse(line)

      if ftp_file_data.directory?
        recursive_list(ftp_file_data.pathname, &block)
      else
        yield(File.join(current_pwd, ftp_file_data.pathname))
      end
    end

    ftp.chdir(saved_pwd)
  end

end
