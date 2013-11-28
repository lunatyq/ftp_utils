class FtpLineParser
  FileListPattern = /^#{'([^\s]+)\s+' * 8 + '(.+)'}$/
  # file mode, number of links, owner name, group name, number of bytes
  # abbreviated month, day-of-month file was last modified,
  # hour file last modified, minute file last modified, and the pathname
  class FtpFileDetails < Struct.new(:file_mode, :links_count, :owner, :group, :bytes,
                               :abbr_month, :day_of_month, :hour_minute,
                               :pathname)
    def directory?
      file_mode[0] == ?d
    end
  end

  def self.parse(line)
    match = line.match(FileListPattern)
    raise "Unable to parse line: #{line.inspect}" unless match
    FtpFileDetails.new(*match.captures)
  end

end
