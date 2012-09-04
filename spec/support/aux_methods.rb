def mock_output(name)
  File.read("#{File.dirname(__FILE__)}/#{name}")
end
