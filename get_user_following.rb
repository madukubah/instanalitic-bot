require_relative 'Bot' 

bot = Bot.new
bot.login( 'alan_12213', 'Alan!234' )

bot.setUserStorePath( 'data/users5' )

lastAct = JSON.parse( File.read("data/last_act.json") ) 
bot.listingFollowersByAPI( 'c76146de99bb02f6415203be841dd25a', lastAct['endCursor'][0..lastAct['endCursor'].length-3] , lastAct['page'] + 1 )

sleep(500)