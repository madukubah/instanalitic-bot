require 'json'
require 'fileutils'
require 'awesome_print' # Console output


$usersPerFile = 100
$saveDataPath = 'preprocessed_data'
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

def removeStopWords( text )
    stopWords = [
        'or',
        'and',
        'on',
        'one',
        'possible',
    ]
    text = text.split(' ')
    text = text.reject { |word| stopWords.include?(word) }.join(' ') 
    return text
end

def categorizePeople( text )
    # text = "555 people person"
    # puts text.index(/\d+ people/)
    if ! text.match(/\d+ people/)
        return text
    end
    a = text.index(/\d+ people/)
    result =  text[a..text.index(/\d people/)  ].to_i
    # puts result

    if result > 2
        text = text.gsub(/\d+ people/,"xxx")
        text = text.gsub(/person/,"")
        text = text.gsub(/ people/,"")
        text = text.gsub(/xxx/,"people")
        # puts text
    elsif result = 2
        text = text.gsub(/\d+ people/,"couple")
        text = text.gsub(/person/,"")
        text = text.gsub(/ people/,"")
        # puts text
    end

    return text

end

def textPreprocessing( text )
    ap text

    text = text.downcase
    if text.include? "image may contain:"
        text.slice! "image may contain:"
    else
        return ''
    end
   
    if text.index('text that says') != nil
        text = text[0..(text.index('that says') - 1)] 
    end
    text = text.gsub(/[,]/ ,"")
    # text = text.gsub( 'people' , 'person')
    text = text.gsub( 'more' , '3')
    text = text.strip
    text = removeStopWords( text )
    text = categorizePeople( text )
    text = text.gsub(/\d+/ ,"")
    text = text.strip
    ap "after : #{text}"
    return text

end

def doPreprocessing( filePath )
    files = Dir[filePath]
    files.each do |file|
        # puts file
        users = JSON.parse( File.read( file ) ) 
        users.each do |user|
            i = 0
            while i < user['images'].length
                user['images'][i]['desc_image'] = textPreprocessing( user['images'][i]['desc_image'] )
                i += 1
                # break
            end        
            # break
        end
        saveUser( users )
        # break
    end
end

fileDataPath = [
    'scanned_user_data_1/users/*',
    'scanned_user_data_2/users/*',
    'scanned_user_data_3/users/*',
    'scanned_users_media/users/*',
]

fileDataPath.each do |path|
    # puts path
    doPreprocessing( path )
    # break
end

