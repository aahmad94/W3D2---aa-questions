require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database

  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end


end



class User

  attr_accessor :id, :fname, :lname

  def self.find_by_id(id)
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    return nil if hash_result.empty?
    User.new(hash_result.first)
  end

  # User::find_by_name(fname, lname)
  def self.find_by_name(fname, lname)
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND
        lname = ?
    SQL
    return nil if hash_result.empty?
    User.new(hash_result.first)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  # User#authored_questions (use Question::find_by_author_id)
  def authored_questions
    Question.find_by_author_id(@id)
  end

  # User#authored_replies (use Reply::find_by_user_id)
  def authored_replies
    Reply.find_by_user_id(@id)
  end

end



class Question

  attr_accessor :id, :title, :body, :author_id

  def self.find_by_id(id)
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    return nil if hash_result.empty?
    Question.new(hash_result.first)
  end

  # Question::find_by_author_id(author_id)
  def self.find_by_author_id(author_id)
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL
    return nil if hash_result.empty?
    hash_result.map { |hash| Question.new(hash) }
  end


  # Question#author

  def author
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, @author_id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
      SQL
    return nil if hash_result.empty?
    User.new(hash_result.first)
  end

  # Question#replies (use Reply::find_by_question_id)


  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end
end



class QuestionFollow

  attr_accessor :id, :user_id, :question_id

  def self.find_by_id(id)
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL
    return nil if hash_result.empty?
    QuestionFollow.new(hash_result.first)
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

end



class Reply

  attr_accessor :user_id, :question_id, :parent_id, :body

  def self.find_by_id(id)
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    return nil if hash_result.empty?
    Reply.new(hash_result.first)
  end

  # Reply::find_by_user_id(user_id)
  def self.find_by_user_id(user_id)
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    return nil if hash_result.empty?
    hash_result.map{ |hash| Reply.new(hash) }
  end

  # Reply::find_by_question_id(question_id)
      #All replies to the question at any depth.
  def self.find_by_question_id(question_id)
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    return nil if hash_result.empty?
    hash_result.map{ |hash| Reply.new(hash) }
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @body = options['body']
  end



  # Reply#author
  def author
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, @user_id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
      SQL
    return nil if hash_result.empty?
    User.new(hash_result.first)
  end

  # Reply#question
  def question
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, @question_id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
      SQL
    return nil if hash_result.empty?
    Question.new(hash_result.first)
  end

  # Reply#parent_reply
  def parent_reply
    Reply.find_by_id(@parent_id) if @parent_id
  end

  # Reply#child_replies
  def child_replies
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL
    return nil if hash_result.empty?
    Reply.new(hash_result.first)
  end

end



class QuestionLike

  attr_accessor :user_id, :question_id

  def self.find_by_id(id)
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL
    return nil if hash_result.empty?
    QuestionLike.new(hash_result.first)
  end

  def initialize(options)
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

end
