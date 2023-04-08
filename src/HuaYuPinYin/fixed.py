#coding=utf8
with open("固顶字.ini", "r", encoding="utf8") as f_in,\
     open("custom_phrase.txt", "w", encoding="utf8", newline="\n") as f_out:
    for line in f_in:
        line = line.rstrip()
        if not line or line.startswith("#"):
            continue
        pinyin, characters = line.split("=")
        f_out.writelines("%s\t%s\t%d\n" % (character, pinyin, frequency)
                         for frequency, character in zip(
                             range(len(characters), 0, -1), characters))
