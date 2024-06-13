import picker from '@ohos.file.picker';

export const photoSelect = (options?: picker.PhotoSelectOptions) => {
  try {
    const photoPicker = new picker.PhotoViewPicker();
    return photoPicker.select(options)
  } catch (err) {
    console.log('photoSelect error: ' + JSON.stringify(err))
  }
}