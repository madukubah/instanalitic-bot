require 'json'
require_relative 'UserScannerBot' 

userScannerBot = UserScannerBot.new( 
    :saveDataPath => 'scanned_user_data_3' ,
    :userDatasPerFile => 10 ,
    :startIndexFile => 30 ,
    :endIndexFile => 39 ,
    )
userScannerBot.login( 'semdoank@ymail.com', 'safril16031' )
userScannerBot.scanUsersImage()