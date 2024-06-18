function open() {
    content.dialogs.fileOpen.open()
    content.dialogs.fileOpen.rejected.connect(() => {
                                                  return
                                              })

    content.dialogs.fileOpen.accepted.connect(() => {
                                                  let filepath = content.dialogs.fileOpen.selectedFile
                                                  console.log(
                                                      filepath.toString())

                                                  content.openMusic(filepath)

                                                  return
                                              })
}
