require 'watir' # Crawler
require 'pry' # Ruby REPL
require 'rb-readline' # Ruby IRB
require 'awesome_print' # Console output
require 'watir-scroll'
require 'net/http'
require 'uri'
require 'json'

$privateUser = Array.new
$unPrivateUser = Array.new
$usersPerFile = 100
def saveUser( newUsers, private = false )
    if( newUsers.length == 0 ) 
        return
    end

    begin
        lastAct = JSON.parse( File.read("filtered_data/last_action.json") ) 
    
        privateFile = ['filtered_data/unprivate_users', 'filtered_data/private_users']
        index = ( private ) ? 1 : 0

        if(File.exist?( privateFile[ index ] + '/users.json')) 
            currUsers = JSON.parse( File.read( privateFile[ index ] + '/users.json' ) ) 
            newUsers = currUsers + newUsers
            File.open( privateFile[ index ] + "/users_#{lastAct[ index ]}.json" ,"w") do |f|
                f.write( newUsers.to_json)
            end
        else
            File.open( privateFile[ index ] + "/users_#{lastAct[ index ]}.json" ,"w") do |f|
                f.write( newUsers.to_json)
            end  
        end

        lastAct[ index ] = lastAct[ index ] + 1
        File.open( "filtered_data/last_action.json","w") do |f|
            f.write( lastAct.to_json)
        end  
    rescue
        ap "failed to save data"
    end
end

def filterPrivate( users )
    users.each do |user|
        if( user['is_private'] )
            $privateUser.push( user )
        else
            $unPrivateUser.push( user )
        end

        if( $privateUser.length == $usersPerFile  )
            saveUser( $privateUser, true )
            $privateUser = Array.new
        end
        if( $unPrivateUser.length == $usersPerFile )
            saveUser( $unPrivateUser )
            $unPrivateUser = Array.new
        end
    end
    
end

files = Dir["data/users5/*"]
# puts files[0]
files.each do |file|
    users = JSON.parse( File.read( file ) ) 
    filterPrivate( users )
    # break
end

# 
