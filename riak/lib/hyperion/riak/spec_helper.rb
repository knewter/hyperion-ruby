def test_app_name
  '_HTEST_'
end

def empty_all_buckets
  ::Riak::Client.new(:protocol => :pbc).buckets.each do |bucket|
    if bucket.name.start_with?(test_app_name)
      bucket.keys.each do |key|
        bucket.delete(key)
      end
    end
  end
end

def with_testable_riak_datastore
  around :each do |example|
    old = ::Riak.disable_list_keys_warnings
    ::Riak.disable_list_keys_warnings = true
    Hyperion.with_datastore(:riak, :app => test_app_name, :protocol => :pbc) do
      example.run
      empty_all_buckets
    end
    ::Riak.disable_list_keys_warnings = old
  end
end