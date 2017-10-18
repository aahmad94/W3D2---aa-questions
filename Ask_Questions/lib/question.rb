class Question

  attr_accessor :id, :title, :body, :author_id

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

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

  # Question#replies (use Reply::find_by_question_id)


  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
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

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end

end
