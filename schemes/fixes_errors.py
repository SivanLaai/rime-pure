import os
def fixes_spell():
    path = './Clover四叶草拼音'
    new_path = './Clover四叶草拼音new'
    if not os.path.exists(new_path):
        os.mkdir(f'{new_path}')
    
    exists_file = list()
    for file_now in os.listdir(path):
        curr_path = os.path.join(path, file_now)
        for line in open(curr_path, encoding='utf-8'):
            if "帧" in line and "zheng" in line:
                exists_file.append(file_now)
                break
    for file_now in exists_file:
        new_file_path = os.path.join(new_path, file_now)
        curr_path = os.path.join(path, file_now)
        new_file = open(new_file_path, 'w', encoding="utf-8")
        print(exists_file)
        for line in open(curr_path, encoding='utf-8'):
            if "帧" in line and "zheng" in line:
                new_file.write(line.replace("zheng", "zhen"))
            else:
                new_file.write(line)

def fixes_unique():
    path = './Clover四叶草拼音'
    new_path = './Clover四叶草拼音new'
    if not os.path.exists(new_path):
        os.mkdir(f'{new_path}')
    files_list = os.listdir(path)
    wordDict = dict()
    repeat_count = 0
    for i in range(len(files_list)):
        curr_path = os.path.join(path, files_list[i])
        for line in open(curr_path, 'r',
                encoding='utf-8'):
            if '\t' in line:
                keyword = line.split('\t')[0]
                count = line.split('\t')[-1].replace(' ',
                        '').strip()
                wordDict[keyword] = wordDict.get(keyword,
                        list())
                if len(wordDict[keyword]) > 0:
                    if wordDict[keyword][0][0] < count:
                        repeat_count = repeat_count + 1
                        wordDict[keyword] = list()
                        wordDict[keyword].append([count, curr_path])
                else:
                    wordDict[keyword].append([count, curr_path])
    for i in range(len(files_list)):
        curr_path = os.path.join(path, files_list[i])
        new_file_path = os.path.join(new_path, files_list[i])
        new_file = open(new_file_path, 'w', encoding="utf-8")

        for line in open(curr_path, 'r', encoding='utf-8'):
            if '\t' in line:
                keyword = line.split('\t')[0]
                count = line.split('\t')[-1].replace(' ', '').strip()
                if len(wordDict[keyword]) > 0:
                    new_file.write(line)
                    wordDict[keyword] = list()
            else:
                new_file.write(line)
    print(repeat_count)
    f = open("result.txt", 'w', encoding='utf-8')
    for key in wordDict:
        if len(wordDict[key]) > 0:
            f.write(key + '\t')
            for node in wordDict[key]:
                f.write(f'[{node[0]}, {node[1]}] ')
            f.write(f'\n')
fixes_unique()
