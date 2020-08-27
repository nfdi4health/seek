require 'test_helper'

class ReindexingJobTest < ActiveSupport::TestCase
  test 'exists' do
    Delayed::Job.delete_all
    assert !ReindexingJob.new.exists?
    assert_difference('Delayed::Job.count', 1) do
      Delayed::Job.enqueue ReindexingJob.new
    end

    assert ReindexingJob.new.exists?
    job = Delayed::Job.first

    assert_nil job.failed_at
    job.failed_at = Time.now
    job.save!
    assert !ReindexingJob.new.exists?, 'Should ignore failed jobs'

    assert_nil job.locked_at
    job.locked_at = Time.now
    job.failed_at = nil
    job.save!
    assert !ReindexingJob.new.exists?, 'Should ignore locked jobs'

    Delayed::Job.delete_all
  end

  test 'add item to queue' do
    Delayed::Job.delete_all
    p = Factory :person
    ReindexingQueue.delete_all
    assert_difference('ReindexingQueue.count') do
      ReindexingQueue.enqueue(p)
    end

    models = [Factory(:model), Factory(:model)]
    ReindexingQueue.delete_all
    assert_difference('ReindexingQueue.count', 2) do
      ReindexingQueue.enqueue(models)
    end
  end
end
