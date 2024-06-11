days = 60

batches = Hyrax::BatchIngest::Batch.where('start_time > ? AND end_time IS NOT NULL', days.days.ago)

rows = batches.map do |batch|
  [
    batch.id,
    batch.ingest_type,
    batch.end_time - batch.start_time,
    batch.created_at
  ]
end

headers = ["Batch ID", "Ingest Type", "Elapsed Time in seconds", "Date"]
rows.unshift(headers)

csv_rows = rows.map { |row| row.join(',') }

File.write("./ams2_batch_ingest_times.past_#{days}_days.csv", csv_rows.join("\n"))
