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

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end
  #   User#average_karma
  # Avg number of likes for a User's questions.
  def average_karma
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        COUNT(user_id)/COUNT(DISTINCT(question_id)) AS avg
      FROM
        questions
      LEFT JOIN
        question_likes on question_likes.question_id = questions.id
      WHERE
        questions.author_id = ?
    SQL
    hash_result[0]["avg"]
  end

end
