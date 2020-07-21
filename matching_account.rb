require 'json'
require 'fileutils'
require 'awesome_print' # Console output


$usersPerFile = 100
$saveDataPath = 'matching_data'
$usersData = Array.new
$files = Dir['filtered_data/unprivate_users_2/*']
for i in 0..33
    # puts file
    users = JSON.parse( File.read( $files[i] ) ) 
    $usersData = $usersData + users
end

ap $usersData.length

def saveUser( data )
    if( data.length == 0 ) 
        return
    end
    FileUtils.mkdir_p( $saveDataPath + '/users_posts' ) unless File.exists?($saveDataPath + '/users_posts') # create save data path
    if ! File.exists?( $saveDataPath + "/last_action.json" ) 
        File.open( $saveDataPath + "/last_action.json","w") do |f|
            lastAct = {
                "last_page" => 0,
            }
            f.write( lastAct.to_json)
        end  
    end

    begin
        lastAct = JSON.parse( File.read( $saveDataPath + "/last_action.json" ) ) 
    
        File.open( $saveDataPath + '/users_posts' + "/data_#{lastAct[ 'last_page' ]}.json" ,"w") do |f|
            f.write( data.to_json)
        end

        lastAct[ 'last_page' ] = lastAct[ 'last_page' ] + 1
        File.open( $saveDataPath + "/last_action.json","w") do |f|
            f.write( lastAct.to_json)
        end  
    rescue
        ap "failed to save data"
    end
end


def searching( username )
    ap 'searching : ' + username
    i = $usersData.length
    $usersData.reverse.each do | user |
        if( user['username'] == username )
            # ap "match!!!"
            $usersData.slice!(i)
            return user
            break
        else
            # ap "false"
        end
        i -= 1
    end
    return nil
end

def doMatching( filePath )
    files = Dir[filePath]
    files.each do |file|
        # puts file
        newUsersData = Array.new
        users = JSON.parse( File.read( file ) ) 
        users.reverse.each do |user|
            foundUser = searching( user['username'] )
            if foundUser != nil
                newUsersData.push(
                    { 
                    "id" => foundUser['id'] ,
                    'username' => foundUser['username'] ,
                    'full_name' => foundUser['full_name'] ,
                    'profile_pic_url' => foundUser['profile_pic_url'] ,
                    'image_count' => user['image_count'] ,
                    'images' => user['images'] ,
                    }
                )
            end
            # break
        end
        saveUser( newUsersData )
        # break
    end
end

fileDataPath = [
    'preprocessed_data/users_posts/*',
]

fileDataPath.each do |path|
    puts path
    doMatching( path )
    # break
end

# ap $newUsersData

ap $usersData.length
