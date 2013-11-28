require File.dirname(__FILE__) + '/../test_helper'

class FtpLineParserTest < ActiveSupport::TestCase

  DirectoryLine = 'drwxr-xr-x   3 ftp      ftp          ' \
                  '4096 Oct 16 07:19 01.07.13'
  FileLine      = '-rw-r--r--   1 ftp      ftp         ' \
                  '75543 Mar  1  2013 2013_96.pdf'

  test 'directory line parsing' do
    details = FtpLineParser.parse(DirectoryLine)

    assert_equal 'drwxr-xr-x', details.file_mode
    assert_equal '01.07.13', details.pathname
  end

  test 'file line parsing' do
    details = FtpLineParser.parse(FileLine)

    assert_equal '-rw-r--r--',  details.file_mode
    assert_equal '2013_96.pdf', details.pathname
  end


  test 'directory recognition' do
    details = FtpLineParser.parse(DirectoryLine)
    assert details.directory?
  end

  test 'file recognition' do
    details = FtpLineParser.parse(FileLine)
    assert !details.directory?
  end

end
