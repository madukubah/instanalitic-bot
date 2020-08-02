require 'json'
require_relative 'Bot' 
require 'fileutils'
require 'pg'
require 'awesome_print' # Console output


require 'pg'

class AccountScannerBot < Bot
    @@conn 
    def initialize( params = {} )
        super
        @@conn = PG.connect :dbname => 'instanalitic', :user => 'madukubah', :password => 'Alan!234'
    end

    def do_scanning( params = {} )
        rs  = @@conn.exec('SELECT * from temp_targets where ( select count(username) from posts where posts.username = temp_targets.username ) = 0 ')
        rs.each do |row|
            ap row
            results = self.scanUserImage( row['username'] )
            ap results
            query = "INSERT INTO posts (id, username, desc_image, source_image, created_at, updated_at, full_name, profile_pic_url, user_id ) VALUES "
            results.each do |image|
                time = Time.new
                time.strftime("%Y-%m-%d %k:%M:%S")
                query =query + "(nextval('post_sequence') , '#{row['username']}', '#{image['desc_image']}', '#{image['source']}', '#{time}', '#{time}', '-', '-', '-' ),"
            end
            if results.length > 0
                query = query[0 .. query.length-2]
                @@conn.exec( query )
            end

        end
    end




end

salesBot = AccountScannerBot.new( )
salesBot.login( 'alan_12213', 'Alan!234' )
salesBot.do_scanning( )

sleep(500)