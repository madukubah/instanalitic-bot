require 'json'
require_relative 'Bot' 
require 'fileutils'

class UserScannerBot < Bot
    @@sourcePath 
    @@userDatasPerFile 
    @@userData= Array.new
    @@saveDataPath 
    @@files 
    def initialize( params = {} )
        super
        @@sourcePath        = params.fetch( :sourcePath,'filtered_data/unprivate_users' )
        @@userDatasPerFile  = params.fetch(:userDatasPerFile , 5)
        @@saveDataPath      = params.fetch(:saveDataPath, 'scanned_user_data' )
        @@startIndexFile    = params.fetch(:startIndexFile, 0 )
        @@endIndexFile      = params.fetch(:endIndexFile, 0 )

        FileUtils.mkdir_p( @@saveDataPath + '/users' ) unless File.exists?(@@saveDataPath + '/users') # create save data path
        if ! File.exists?( @@saveDataPath + "/last_action.json" ) 
            File.open( @@saveDataPath + "/last_action.json","w") do |f|
                lastAct = {
                    "index_file" => @@startIndexFile,
                    "last_page" => 0,
                    "index_user" => 0
                }
                f.write( lastAct.to_json)
            end  
        end
    end

    def loadData()
        @@files = Dir[ @@sourcePath + "/*"]
        if( @@endIndexFile == 0 )
            @@endIndexFile = @@files.length
        end
    end

    def saveData( data )
        ap 'save data'
        lastAct = JSON.parse( File.read( @@saveDataPath + "/last_action.json" ) ) 
    
        File.open( @@saveDataPath + "/users/users_#{ lastAct['last_page'] }.json","w") do |f|
            f.write( data.to_json)
        end 
    
        lastAct['last_page'] = lastAct['last_page'] + 1
        File.open( @@saveDataPath + "/last_action.json","w") do |f|
            f.write( lastAct.to_json)
        end  
    end

    def updateIndexFile( index )
        lastAct = JSON.parse( File.read( @@saveDataPath + "/last_action.json" ) ) 
    
        lastAct['index_file'] = index
        File.open( @@saveDataPath + "/last_action.json" ,"w") do |f|
            f.write( lastAct.to_json)
        end  
    end

    def updateUserIndex( index )
        lastAct = JSON.parse( File.read( @@saveDataPath + "/last_action.json" ) ) 
    
        lastAct['index_user'] = index
        File.open( @@saveDataPath + "/last_action.json" ,"w") do |f|
            f.write( lastAct.to_json)
        end  
    end

    def scanUsersImage()
        self.loadData()
        lastAct = JSON.parse( File.read( @@saveDataPath + "/last_action.json" ) ) 
        startIndexFile = lastAct['index_file']
        userIndex = lastAct['index_user']
        if startIndexFile == @@endIndexFile
            ap 'finished....'
            return
        end
        for i in startIndexFile..@@endIndexFile
            users = JSON.parse( File.read( @@files[i] ) )
        
            for j in userIndex..users.length
                begin
                    results = self.scanUserImage( users[j]['username'] )
                    ap users[j]['username']
                    @@userData.push(
                        { 
                        "id" => users[j]['id'] ,
                        'username' => users[j]['username'] ,
                        'full_name' => users[j]['full_name'] ,
                        'profile_pic_url' => users[j]['profile_pic_url'] ,
                        'image_count' => results.length ,
                        'images' => results ,
                        }
                    )
                    
                    updateUserIndex( j + 1 )
                    if( @@userData.length == @@userDatasPerFile )
                        self.saveData( @@userData )
                        @@userData = Array.new
                        # bot.login( 'username', 'pass' )
                    end
                rescue
                    ap "failed... skip"
                    sleep(60)
                end
                
            end
            self.updateIndexFile( i + 1 )
            userIndex = 0
            self.updateUserIndex( userIndex ) # renew index
            # break
        end
    end
end


# https://www.instagram.com/graphql/query/?

# query_hash=e769aa130647d2354c40ea6a439bfc08 -> get users media :v
# &
# variables=
#     %7B -> # {
#     %22 -> # "
#         id
#     %22
#     %3A -> # :
#     %22
#         8613340861 
#     %22
#     %2C -> # ,
#     %22
#         first
#     %22
#     %3A
#         12
#     %2C
#     %22
#         after
#     %22
#     %3A
#     %22
#         QVFEaHdqLTZsNlAzOV9PRW9VUEdlbWhiN0Zwajk4TnA3amJacG1uMkxjMzcxUWQ1dnNNMDVtMXZMUjFvaHc0RGx1Z1JRODRfZVFzZmlWd1VEMEpZQmtPdg
#     %3D -> #=
#     %3D
#     %22
#     %7D -> # }

#     https://www.instagram.com/graphql/query/?query_hash=e769aa130647d2354c40ea6a439bfc08&variables=%7B%22id%22%3A%228613340861%22%2C%22first%22%3A12%7D
