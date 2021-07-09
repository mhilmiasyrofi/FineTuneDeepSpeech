import pandas as pd
from pathlib import Path

from sklearn.model_selection import train_test_split

def read_transcription(fpath):
    with open(fpath, "r") as f :
        return f.readlines()[0]

if __name__ == "__main__" :
    ftc_dir = Path("../data/europarl-seed2021/rv/wav2vec2/")

    files = ftc_dir.glob('*.txt')

    audios = []
    transcriptions = []

    for fpath in files :
        # print(f.absolute())
        # print(fpath)
        audio_fpath = str(fpath).replace("../", "/DeepSpeech/").replace(".txt", ".wav")
        # print(audio_fpath)
        transcription = read_transcription(fpath)
        audios.append(audio_fpath)
        transcriptions.append(transcription)
       
    df = pd.DataFrame(data={"wav_filename": audios,"transcript":transcriptions})
    print(len(df))
    train, test = train_test_split(df, test_size=0.1)

    train.to_csv("../data/europarl-seed2021/rv-wav2vec2-train.csv", index=False)
    test.to_csv("../data/europarl-seed2021/rv-wav2vec2-test.csv", index=False)
