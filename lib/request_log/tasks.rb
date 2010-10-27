Dir[File.join(File.dirname(__FILE__), "..", "tasks", "*.rake")].each { |rake_file| load rake_file }
