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
