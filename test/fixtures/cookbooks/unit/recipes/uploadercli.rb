pacifica_uploader 'default' do
  python_opts(
    provider: :system,
    version: '2.7'
  )
end
pacifica_uploadercli 'default' do
  python_opts(
    provider: :system,
    version: '2.7'
  )
end
