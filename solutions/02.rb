class Song
  attr_accessor :name, :artist, :genre, :subgenre, :tags
  
  def initialize(name, artist, genre, subgenre, tags)
    @name     = name
    @artist   = artist
    @genre    = genre
    @subgenre = subgenre
    @tags     = tags
  end
  
  def matches?(criteria)
    criteria.all? { |type, filter| matches_criteria? type, filter }
  end
  
  private 
  
  def matches_criteria?(type, filter)
    #Интересно ми е това добра идея ли е да се подравнява по този начин?
    case type
      when :filter  then filter.(self)
      when :tags    then match_tags_criteria? filter
      when :name    then @name == filter
      when :artist  then @artist == filter
    end
  end
  
  def matches_tag_criteria?(tag)
    tag.end_with?("!") ^ tags.include?(tag.chomp "!")
  end
  
  def match_tags_criteria?(tags)
    Array(tags).all? { |tag| matches_tag_criteria? tag }
  end
end

class Collection
  attr_reader :songs
  def initialize(songs_string, additional_tags)
    parse_songs songs_string
    add_additional_tags additional_tags
  end
  
  def find(criteria = {})
    @songs.select { |song| song.matches? criteria }
  end
  
  private
  
  def parse_songs(songs_string)
    @songs = songs_string.lines.map { |line| parse_line line }
  end
  
  def parse_line(line)
    song_info       = line.split('.').map(&:strip)
    name, artist    = song_info[0], song_info[1]
    genre, subgenre = song_info[2].split(',').map(&:strip)
    tags            = [genre, subgenre].compact.map(&:downcase)
    tags            += song_info[3].split(',').map(&:strip) if song_info[3]
    
    Song.new name, artist, genre, subgenre, tags
  end
  
  def add_additional_tags(additional_tags)
    return if not additional_tags
    additional_tags.each do |name, tags|
      songs = find artist: name      
      songs = songs.map { |song| song.tags+=tags }
    end
  end
end