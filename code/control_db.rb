require "postgres"

#データベースコントロールの基礎となるクラス
class ControlDB
  #クラスを作ったときに自動初期化する(デフォルト設定）
  def initialize()
    @hostname = "localhost"
    @databasename = "postgres"
    @tablename = "testtable"
    @user=""
    @pass=""
    @exec_array=[]
  end

  #ホスト名を自分で設定する
  def set_hostaname(hostname)
    @hostname = hostname
  end

  def get_hostname()
    return @hostname
  end

  #データベース名を自分で設定する
  def set_databasename(databasename)
    @databasename = databasename
  end

  def get_databasename()
    return @databasename
  end

  #テーブル名を自分で設定する
  def set_tablename(tablename)
    @tablename = tablename
  end

  def get_tablename()
    return @tablename
  end

  #ユーザ名を自分で設定
  def set_user(user)
    @user = user
  end

  def get_user()
    return @user
  end

  #パスワードを自分で設定
  def set_password(pass)
    @pass = pass
  end

  def get_password()
    return @pass
  end


  #配列にした命令群をデータベースに実行させる
  def exec_database(array)
    begin
      database = PGconn.connect(@hostname, 5432,
				@user, @pass, @databasename)
      array.each do |exec_string|
	database.exec(exec_string)
      end
      
    rescue
      puts("Error Occured in Communicating Postgres.")
      exit(1)
    end
  end

  #データベース一覧を取得する(作りかけ）
  def database_list()
    #result = ""
    #begin
    #  database = PGconn.connect(@hostname, 5432,
	#			@user, @pass, @databasename)
    #  result = database.exec('')
    #rescue
    #  puts("Error Occured in Communicating Postgres.")
    #end
    #for j in 0..(result.num_tuples) do

    #  for i in 0..result.num_fields do
	#print("result[j][i]\t")
      #end
      #puts("")
    #end


    #苦肉の作 ;-)
    system("psql -l")

  end

  #テーブル一覧を取得する（作りかけ）
  def table_list()
    #result = ""
    #begin
    #  database = PGconn.connect(@hostname, 5432,
	#			@user, @pass, @databasename)
    #  result = database.exec('')
    #  puts("in")
    #rescue
    #  puts("Error Occured in Communicating Postgres.")
    #end
    #for j in 0..(result.num_tuples) do

    #  for i in 0..result.num_fields do
	#print("result[j][i]\t")
      #end
      #puts("")
    #end

    #苦肉の作 ;-)
    system("psql #{@databasename} -c \\\\dt")

  end

  #データベース削除
  def delete_db(db_deleted)
    begin
      database = PGconn.connect(@hostname, 5432,
				@user, @pass, @databasename)
      result = database.exec("drop database #{db_deleted};")
    rescue
      puts("Error Occured in Communicating Postgres.")
      exit(1)
    end
    puts ("Ended Deleting Database #{db_deleted}.")

  end

  #テーブル削除
  def delete_table(table_deleted)
    begin
      database = PGconn.connect(@hostname, 5432,
				@user, @pass, @databasename)
      result = database.exec("drop table #{table_deleted};")
    rescue
      puts("Error Occured in Communicating Postgres.")
      exit(1)
    end
    puts ("Ended Deleting Table #{table_deleted} in #{@databasename}.")

  end

end


#CSV登録用のクラス
class CSV_InputDB < ControlDB
  
  #テーブルを列数maxcolumnで作成する
  def create_table(tablename, maxcolumn)
    exec_string = "create table #{tablename} ("
    for x in 1..maxcolumn do
      exec_string = exec_string + "column#{x} text"
      unless x == maxcolumn then
	exec_string = exec_string + ","
      end
    end
    return exec_string = exec_string + ");"
  end

  #テーブルに1行(配列で指定(data_array))データを挿入する
  #注！ 今は配列の最後のデータの、最後の文字が改行であると仮定
  def insert_value(tablename, data_array)
    exec_string = "insert into #{tablename} values("
    for j in 0..(data_array.length)-1 do
      
      if j != (data_array.length)-1 then
	exec_string = exec_string + "'#{data_array[j]}'\s"
	exec_string = exec_string + ","
      else
	exec_string = exec_string + "'#{data_array[j].chomp!}'\s"
      end
    end
    exec_string = exec_string + ");"
    return exec_string
  end

  #ファイルの最大列数を調べる
  def max_column_of_file(filename)
    maxcolumn = 1
    maxraw = 0
    data_array = [0,1,2]
    File.open(filename) do |file|
      file.readlines.each do |line|
	data_array = line.split(',')
	if data_array.length > maxcolumn then
	  maxcolumn = data_array.length
	end
      end
    end
    return maxcolumn
  end

  #実際にデータベースと交信し、
  #CSVファイルからデータベースに入力を行なう。
  def input_value(filename)
    maxcolumn = max_column_of_file(filename)
    @exec_array[0] = create_table(@tablename, maxcolumn)

    File.open(filename) do |file|
      file.readlines.each_with_index do |line,j|
	data_array = line.split(',')
	@exec_array[j+1] = insert_value(@tablename, data_array)
      end
    end

    exec_database(@exec_array)

  end

end
#クラスはここで終了
