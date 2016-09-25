require 'test_helper'

class ScannersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @scanner = scanners(:one)
  end

  test "should get index" do
    get scanners_url
    assert_response :success
  end

  test "should get new" do
    get new_scanner_url
    assert_response :success
  end

  test "should create scanner" do
    assert_difference('Scanner.count') do
      post scanners_url, params: { scanner: { pattern: @scanner.pattern, tag: @scanner.tag } }
    end

    assert_redirected_to scanner_url(Scanner.last)
  end

  test "should show scanner" do
    get scanner_url(@scanner)
    assert_response :success
  end

  test "should get edit" do
    get edit_scanner_url(@scanner)
    assert_response :success
  end

  test "should update scanner" do
    patch scanner_url(@scanner), params: { scanner: { pattern: @scanner.pattern, tag: @scanner.tag } }
    assert_redirected_to scanner_url(@scanner)
  end

  test "should destroy scanner" do
    assert_difference('Scanner.count', -1) do
      delete scanner_url(@scanner)
    end

    assert_redirected_to scanners_url
  end
end
