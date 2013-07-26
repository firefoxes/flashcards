class Card
  attr_reader :definition , :answer

  def initialize(card_array)
    @definition, @answer = card_array.map(&:chomp)
  end

  def hint
    "The first letter of the answer is #{@answer[0]} "
  end
end

class Deck
  attr_reader :next_question

  def self.load(file = 'flashcard_samples.txt')
    data = []
    File.open(file).each_line { |line| data << line}
    card_array = []
    data.each_slice(3) {|line_group| card_array << Card.new(line_group)}
    new(card_array)
  end

  def initialize(card_obj_array)
    @card_array = card_obj_array
  end

  def shuffle
    @card_array.shuffle!
  end

  def next_question
    current_card = @card_array.shift
    @card_array.push current_card
    current_card
  end
end

class FlashcardController
  def initialize
    @deck = Deck.load
    @card = nil
    @answered = false
  end

  def quiz_me
    @answered = false
    @card = @deck.next_question
    puts @card.definition
  end

  def answered?
    @answered
  end

  def hint
    puts @card.hint
  end

  def shuffle
    @deck.shuffle
  end

  def evaluate(input)
    if @card.answer == input
      puts "Correct."
      @answered = true
    else
      puts "Incorrect, try again."
    end
  end
end

test = FlashcardController.new

loop do
  test.quiz_me
  until test.answered?
    input = gets.chomp
    case input
    when "quit" then break
    when "hint" then test.hint
    when "shuffle"
      test.shuffle
      test.quiz_me
    when "skip"
      test.quiz_me
    else test.evaluate(input)
    end
  end
  break if input == "quit"
end
