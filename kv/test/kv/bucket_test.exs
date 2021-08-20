defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  setup do
    bucket = start_supervised!(KV.Bucket)
    %{bucket: bucket}
  end

  test "stores value by key", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk" , 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end

  test "deletes value by key", %{bucket: bucket} do
    # add milk and bread
    KV.Bucket.put(bucket, "milk" , 3)
    KV.Bucket.put(bucket, "bread" , 1)

    # verify
    assert KV.Bucket.get(bucket, "milk") == 3
    assert KV.Bucket.get(bucket, "bread") == 1

    # remove bread
    assert KV.Bucket.delete(bucket, "bread") == 1

    # verify
    assert KV.Bucket.get(bucket, "bread") == nil
    assert KV.Bucket.get(bucket, "milk") == 3
  end

end
