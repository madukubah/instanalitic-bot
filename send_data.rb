require 'fileutils'
require 'json'
require 'net/http'

@error = 0
@success = 0
def create_agent( data )
    uri = URI('http://localhost:8080/posts')
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    req.body = data.to_json
    res = http.request(req)
    # puts "response #{res.body}"
    @success = @success + 1

    puts "berhasil #{ @success }" 
    puts "gagal #{ @error }" 
rescue => e
    # puts "failed #{e}"
    @error = @error + 1

    puts "berhasil #{ @success }" 
    puts "gagal #{ @error }" 
end

def readFile( file )
    users = JSON.parse( File.read( file ) ) 
    # puts users[0]["id"]
    users.each do |user|
        # puts user
        data = {};
        user["images"].each do |image|
            data = {
                "user_id"       => user["id"],
                "username"      => user["username"],
                "full_name"     => user["full_name"],
                "profile_pic_url" => user["profile_pic_url"],
                "desc_image"    => image["desc_image"],
                "source_image"  => image["source"],
            } 
            # puts data
            create_agent( data )
            # break
        end
        # break
    end
end

files = Dir['matching_data/users_posts/*']
files.each do |file|
    puts file
    readFile( file )
    # break
end

puts "berhasil #{ @success }" 
puts "gagal #{ @error }" 