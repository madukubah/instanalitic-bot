require 'json'
require_relative 'UserScannerBot' 

userScannerBot = UserScannerBot.new( 
    :saveDataPath => 'scanned_user_data_1' ,
    :userDatasPerFile => 10 ,
    :startIndexFile => 10 ,
    :endIndexFile => 19 ,
    )
userScannerBot.login( 'alan_12213', 'Alan!234' )
userScannerBot.scanUsersImage()