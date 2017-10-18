class QuestionLike

  attr_accessor :user_id, :question_id

  def self.most_liked_questions(n)
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        question_likes
      JOIN
        questions ON questions.id = question_likes.question_id
      GROUP BY
        question_likes.question_id -- questions.*
      ORDER BY
        COUNT(question_likes.user_id) DESC
      LIMIT
        ?
    SQL

    hash_result.map { |hash| Question.new(hash) }
  end

  def self.liked_questions_for_user_id(user_id)
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_likes
      JOIN
        questions ON question_likes.question_id = questions.id
      WHERE
        question_likes.user_id = ?
      SQL
    hash_result.map { |hash| Question.new(hash) }
  end

  def self.likers_for_question_id(question_id)
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_likes
      JOIN
        users ON question_likes.user_id = users.id
      WHERE
        question_likes.question_id = ?
      SQL
    hash_result.map { |hash| User.new(hash) }
  end

  def self.num_likes_for_question_id(question_id)
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(user_id) AS count
      FROM
        question_likes
      WHERE
        question_likes.question_id = ?
      GROUP BY
        question_id
      SQL
    hash_result[0]["count"]
    # hash_result.map { |hash| User.new(hash) }
  end

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
