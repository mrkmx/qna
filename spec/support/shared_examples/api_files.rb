shared_examples_for 'API files' do
  include Rails.application.routes.url_helpers

  context 'files' do
    let(:file) { item.files.first.blob }
    let(:files_response) { object_response['files'] }
    let(:file_response) { files_response.first }

    it 'rerurn list of files' do
      expect(files_response.size).to eq item.files.size
    end

    it 'returns all public fields' do
      %w[id filename].each do |attr|
        expect(file_response[attr]).to eq file.send(attr).as_json
      end
    end

    it 'contains link to file' do
      expect(file_response['file_url']).to eq rails_blob_path(file).as_json
    end
  end
end
