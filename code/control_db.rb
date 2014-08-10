require "postgres"

#�ǡ����١�������ȥ���δ��äȤʤ륯�饹
class ControlDB
  #���饹���ä��Ȥ��˼�ư���������(�ǥե���������
  def initialize()
    @hostname = "localhost"
    @databasename = "postgres"
    @tablename = "testtable"
    @user=""
    @pass=""
    @exec_array=[]
  end

  #�ۥ���̾��ʬ�����ꤹ��
  def set_hostaname(hostname)
    @hostname = hostname
  end

  def get_hostname()
    return @hostname
  end

  #�ǡ����١���̾��ʬ�����ꤹ��
  def set_databasename(databasename)
    @databasename = databasename
  end

  def get_databasename()
    return @databasename
  end

  #�ơ��֥�̾��ʬ�����ꤹ��
  def set_tablename(tablename)
    @tablename = tablename
  end

  def get_tablename()
    return @tablename
  end

  #�桼��̾��ʬ������
  def set_user(user)
    @user = user
  end

  def get_user()
    return @user
  end

  #�ѥ���ɤ�ʬ������
  def set_password(pass)
    @pass = pass
  end

  def get_password()
    return @pass
  end


  #����ˤ���̿�ᷲ��ǡ����١����˼¹Ԥ�����
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

  #�ǡ����١����������������(��꤫����
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


    #�����κ� ;-)
    system("psql -l")

  end

  #�ơ��֥�������������ʺ�꤫����
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

    #�����κ� ;-)
    system("psql #{@databasename} -c \\\\dt")

  end

  #�ǡ����١������
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

  #�ơ��֥���
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


#CSV��Ͽ�ѤΥ��饹
class CSV_InputDB < ControlDB
  
  #�ơ��֥�����maxcolumn�Ǻ�������
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

  #�ơ��֥��1��(����ǻ���(data_array))�ǡ�������������
  #�� ��������κǸ�Υǡ����Ρ��Ǹ��ʸ�������ԤǤ���Ȳ���
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

  #�ե�����κ��������Ĵ�٤�
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

  #�ºݤ˥ǡ����١����ȸ򿮤���
  #CSV�ե����뤫��ǡ����١��������Ϥ�Ԥʤ���
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
#���饹�Ϥ����ǽ�λ
