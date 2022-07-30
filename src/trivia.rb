require 'http'

response = HTTP.get("http://jservice.io/api/random").parse

pp response