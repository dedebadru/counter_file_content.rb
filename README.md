# Counter File Content

This Ruby script scans a directory for files and calculates how many files have the same content. It will output the most frequent file content along with the number of files that share the same content.

- Ruby 2.x or later is required to run the script.

## How to Run

1. Clone or download the repository to your local machine.
2. Ensure you have Ruby installed on your system.
3. Navigate to the directory where the script is located.
4. Run the script via the terminal with the following command:
```bash
ruby coun <directory_path>
```
   or
```bash
chmod +x coun
./coun <directory_path>
```

## How to Test

1. Install `rspec` with bundle install
2. run the test with command:
```bash
rspec spec/file_content_counter_spec.rb
```

## Example
<img width="534" alt="Example" src="https://github.com/user-attachments/assets/422f4671-a8b5-48a2-beaa-74e1ad2b6794" />
