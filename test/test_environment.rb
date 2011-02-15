require 'sprockets_test'

class TestEnvironment < Sprockets::TestCase
  def setup
    @env = Sprockets::Environment.new(".", {})
    @env.paths << fixture_path('default')
  end

  test "working directory is the default root" do
    assert_equal Dir.pwd, @env.root
  end

  test "resolve in environment" do
    assert_equal fixture_path('default/gallery.js'),
      @env.resolve("gallery.js").path
  end

  test "missing file raises an exception" do
    assert_raises(Sprockets::FileNotFound) do
      @env.resolve("null")
    end
  end

  test "build static asset" do
    assert_equal "Hello world\n", @env.build_asset("hello.txt").to_s
  end

  test "build asset returns nil if file is missing" do
    assert_nil @env.build_asset("null")
  end

  test "find concatenated asset in environment" do
    assert_equal "var Gallery = {};\n", @env["gallery.js"].to_s
  end

  test "find static asset in environment" do
    assert_equal "Hello world\n", @env["hello.txt"].to_s
  end

  test "find asset with digest" do
    assert_equal "Hello world\n",
      @env["hello.txt", "33ab5639bfd8e7b95eb1d8d0b87781d4ffea4d5d"].to_s
  end

  test "find asset with blank digest" do
    assert_equal "Hello world\n",
      @env["hello.txt", ""].to_s
  end

  test "find asset with invalid digest" do
    assert_nil @env["hello.txt", "invalid"]
  end

  test "missing asset returns nil" do
    assert_equal nil, @env["missing.js"]
  end

  test "asset with missing requires raises an exception" do
    assert_raises Sprockets::FileNotFound do
      @env["missing_require.js"]
    end
  end

  test "lookup asset digest" do
    assert_equal "4088f98ded5fdf9b60db467cb6c346926d9bedfc",
      @env["gallery.js"].digest
  end
end
