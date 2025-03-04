require 'rspec'
require 'fileutils'
require 'digest'
require 'find'
require_relative '../file_content_counter'

RSpec.describe FileContentCounter do
  before(:all) do
    @directory_path = 'spec/test_directory'
    @file1 = 'spec/test_directory/file1.txt'
    @file2 = 'spec/test_directory/file2.txt'
    @file3 = 'spec/test_directory/file3.txt'

    # Ensure the test directory exists and files are written before tests
    FileUtils.mkdir_p(@directory_path)
    File.write(@file1, 'This is a test file.')
    File.write(@file2, 'This is another test file.')
    File.write(@file3, 'This is a test file.')  # Same content as @file1
  end

  after(:all) do
    # Clean up the test files after tests are done
    FileUtils.rm_rf(@directory_path)
  end

  describe '#calculate_file_hash' do
    it 'calculates a SHA256 hash for the content of a file' do
      file_hash, _content = FileContentCounter.calculate_file_hash(@file1)
      expect(file_hash).to be_a(String)
      expect(file_hash.length).to eq(64)  # SHA256 hash is always 64 characters long
    end

    it 'calculates the same hash for files with the same content' do
      hash1, _content1 = FileContentCounter.calculate_file_hash(@file1)
      hash2, _content2 = FileContentCounter.calculate_file_hash(@file3)
      expect(hash1).to eq(hash2)
    end

    it 'calculates different hashes for files with different content' do
      hash1, _content1 = FileContentCounter.calculate_file_hash(@file1)
      hash2, _content2 = FileContentCounter.calculate_file_hash(@file2)
      expect(hash1).not_to eq(hash2)
    end
  end

  describe '#scan_directory' do
    it 'scans the directory and returns the most frequent file content' do
      content, count = FileContentCounter.scan_directory(@directory_path)
      expect(content).to eq('This is a test file.')  # @file1 and @file3 have the same content
      expect(count).to eq(2)  # Both @file1 and file3 have the same content
    end

    it 'handles an empty directory gracefully' do
      empty_directory = 'spec/empty_directory'
      FileUtils.mkdir_p(empty_directory)

      content, count = FileContentCounter.scan_directory(empty_directory)
      expect(content).to be_nil
      expect(count).to be_nil

      # Clean up the empty directory
      FileUtils.rm_rf(empty_directory)
    end

    it 'returns the correct count for directories with unique content' do
      unique_directory = 'spec/unique_directory'
      FileUtils.mkdir_p(unique_directory)

      # Create new file with unique content
      File.write("#{unique_directory}/file1.txt", 'Unique content')

      content, count = FileContentCounter.scan_directory(unique_directory)
      expect(content).to eq('Unique content')
      expect(count).to eq(1)

      FileUtils.rm_rf(unique_directory)
    end
  end

  describe '#execute' do
    it 'handles a valid directory path and prints the result' do
      allow(FileContentCounter).to receive(:puts)
      expect(FileContentCounter).to receive(:puts).with("This is a test file. 2")
      FileContentCounter.execute(@directory_path)
    end

    it 'prints an error message when the directory does not exist' do
      allow(FileContentCounter).to receive(:puts)
      invalid_directory = 'spec/non_existent_directory'
      expect(FileContentCounter).to receive(:puts).with("Error: Directory '#{invalid_directory}' does not exist.")
      FileContentCounter.execute(invalid_directory)
    end
  end
end