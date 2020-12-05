require 'json'
require_relative 'UserScannerBot' 

userScannerBot = UserScannerBot.new( 
    :saveDataPath => 'scanned_user_data_2' ,
    :userDatasPerFile => 10 ,
    :startIndexFile => 20 ,
    :endIndexFile => 29 ,
    )
userScannerBot.login( 'username', 'pass' )
userScannerBot.scanUsersImage()