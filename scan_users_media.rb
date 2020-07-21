require 'json'
require_relative 'Bot' 


$sourcePath = 'filtered_data/unprivate_users'
$userDatasPerFile = 10
$userData= Array.new
$usersHasNoData= 0

files = Dir[ $sourcePath + "/*"]


def saveData( data )
    lastAct = JSON.parse( File.read("scanned_users_media/last_action.json") ) 

    File.open( "scanned_users_media/users/users_#{ lastAct['last_page'] }.json","w") do |f|
        f.write( data.to_json)
    end 

    lastAct['last_page'] = lastAct['last_page'] + 1
    File.open( "scanned_users_media/last_action.json","w") do |f|
        f.write( lastAct.to_json)
    end  
end

def updateIndexFile( index )
    lastAct = JSON.parse( File.read("scanned_users_media/last_action.json") ) 

    lastAct['index_file'] = index
    File.open( "scanned_users_media/last_action.json","w") do |f|
        f.write( lastAct.to_json)
    end  
end

def updateUserIndex( index )
    lastAct = JSON.parse( File.read("scanned_users_media/last_action.json") ) 

    lastAct['index_user'] = index
    File.open( "scanned_users_media/last_action.json","w") do |f|
        f.write( lastAct.to_json)
    end  
end


bot = Bot.new
bot.login( 'muhammadalfalahmadukubah', 'alanalin' )
# bot.login( 'alan_12213', 'Alan!234' )
# bot.scanUserImage( 'fenih13' )

lastAct = JSON.parse( File.read("scanned_users_media/last_action.json") ) 
$fileIndex = lastAct['index_file']
$userIndex = lastAct['index_user']

for i in $fileIndex..files.length
    users = JSON.parse( File.read( files[i] ) ) 

    for j in $userIndex..users.length
        begin
            results = bot.scanUserImage( users[j]['username'] )
            ap users[j]['username']
            $userData.push(
                { 
                'username' => users[j]['username'] ,
                'image_count' => results.length ,
                'images' => results ,
                }
            )
            if( results.length == 0 )
                $usersHasNoData = $usersHasNoData + 1
            end 
            updateUserIndex( j + 1 )
            if( $userData.length == $userDatasPerFile )
                saveData( $userData )
                $userData = Array.new
                # bot.login( 'muhammadalfalahmadukubah', 'alanalin' )
            end
        rescue
            ap "failed... skip"
            sleep(60)
        end
        
    end
    updateIndexFile( i + 1 )
    $userIndex = 0
    $usersHasNoData = 0
    updateUserIndex( $userIndex ) # renew index
    # break
end

if( $userData.length > 0 )
    saveData( $userData )
end

# saveData( $userData )