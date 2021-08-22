import os
import sys
sys.path.append("./exact-pinyin-mark")
from opencc import OpenCC
from PinyinDataBuild import PinyinDataBuild
pdb = PinyinDataBuild(loadJieba=False)

def simplify(to_convert):
    if '\t' in to_convert:
        keyword = to_convert.split('\t')[0]
        remain = "\t".join(to_convert.split('\t')[1:])
    else:
        return to_convert
    cc = OpenCC('t2s')  # convert from Simplified Chinese to Traditional Chinese
    # can also set conversion by calling set_conversion
    # cc.set_conversion('s2tw')
    converted = cc.convert(keyword)
    converted = converted + "\t" + remain
    return converted

def simplifyFile(path, new_path):
    file = open(path, "r", encoding="utf8")
    newFile = open(new_path, "w", encoding="utf8")
    for line in file.readlines():
        newFile.write(simplify(line))
        newFile.flush()

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
# 词频不一样的去重
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

# 词频不一样的去重
def fixes_unique_with_same_pinyin():
    path = './Clover四叶草拼音'
    new_path = './Clover四叶草拼音new'
    if not os.path.exists(new_path):
        os.mkdir(f'{new_path}')
    files_list = os.listdir(path)
    wordDict = set()
    repeat_count = 0

    for i in range(len(files_list)):
        curr_path = os.path.join(path, files_list[i])
        new_file_path = os.path.join(new_path, files_list[i])
        new_file = open(new_file_path, 'w', encoding="utf-8")

        for line in open(curr_path, 'r', encoding='utf-8'):
            if '\t' in line:
                keyword = line.split('\t')[0]
                pinyin = line.split('\t')[1].replace(' ', '').strip()
                key = keyword + pinyin
                if key not in wordDict:
                    new_file.write(line)
                    wordDict.add(key)
            else:
                new_file.write(line)

def generateNewBaseDict():
    f = open('./Clover四叶草拼音/clover.base.dict.yaml', 'w')
    homographDict = statisticHomograph()
    for line in open('./Clover四叶草拼音/clover.base-back.dict.yaml', 'r'):
        if '\t' not in line:
            f.write(line)
            f.flush()
        else:
            line = line.strip()
            keyword = line.split('\t')[0]
            if keyword in homographDict:
                countStr = line.split('\t')[2]
                oldPinyin = line.split('\t')[1]
                count = float(countStr)
                sumCount = sum([int(num) for num in homographDict[keyword].values()])
                for pinyin in homographDict[keyword]:
                    newCount = 1
                    if sumCount != 0:
                        newCount = int(count * float(homographDict[keyword][pinyin]) / sumCount)
                    if newCount == 0:
                        newCount = 1
                    newCountStr = str(newCount)
                    newLine = line.replace(oldPinyin, pinyin).replace(countStr, newCountStr)
                    f.write(newLine + '\n')
                    f.flush()
            else:
                f.write(line + '\n')
                f.flush()


# 统计所有词汇表中多音字的出现频率
def statisticHomograph():
    homoDict = pdb.homographWeightDict
    homoStatisticDict = dict()
    for homo in homoDict:
        if len(homo) == 1 and  len(homoDict[homo]["plainPinyins"]) >= 2:
            if homo not in homoStatisticDict:
                homoStatisticDict[homo] = dict()
            for plainPinyin in homoDict[homo]["plainPinyins"]:
                    homoStatisticDict[homo][plainPinyin] = homoStatisticDict[homo].get(plainPinyin, 0)
    for word in pdb.phrasePinyinDict:
        for w in word:
            if w in homoStatisticDict:
                plainPinyins = pdb.phrasePinyinDict[word]["plainPinyins"]
                for plainPinyin in plainPinyins:
                    plains = plainPinyin.split(" ")
                    if len(plains) <= 1:
                        continue
                    for currPinyin in homoStatisticDict[w].keys():
                        if currPinyin in plainPinyin:
                            homoStatisticDict[w][currPinyin] = homoStatisticDict[w].get(currPinyin, 0) + 1
    return homoStatisticDict

# 得到所有正确的汉字拼音标识
def getBasicWordMap():
    wordMap = dict()
    path = './data'
    for file_now in os.listdir(path):
        curr_path = os.path.join(path, file_now)
        #print(curr_path)
        for line in open(curr_path, encoding='utf-8'):
            if '\t' in line:
                keyword = line.split('\t')[0]
                pinyin = line.split('\t')[1].strip()
                wordMap[keyword] = pinyin
    return wordMap

def getPinyin(keyword):
    #print(keyword)
    pinyins = pdb.getPinyin(keyword)
    #print(pinyins)
    return pinyins


BasicWordMap = getBasicWordMap()
def getBasicPinyin(keyword):
    if len(keyword) == 1:
        pinyinStrList = list()
        return pinyinStrList
    else:
        wordPinyin = BasicWordMap.get(keyword, None)
        pinyinFinalList = list()
        if wordPinyin is None:
            return list()
        else:
            pinyinFinalList.append(wordPinyin)
            return pinyinFinalList

# 修复大字典的拼音错误
def fixesBigDictErrorsWithBasic():
    path = './Clover四叶草拼音'
    new_path = './Clover四叶草拼音new'
    
    if not os.path.exists(new_path):
        os.mkdir(f'{new_path}')
    for file_now in os.listdir(path):
        new_file_path = os.path.join(new_path, file_now)
        curr_path = os.path.join(path, file_now)
        new_file = open(new_file_path, 'w', encoding="utf-8")
        for line in open(curr_path, encoding='utf-8'):
            if "\t" in line:
                keyword = line.split('\t')[0]
                pinyin_old = line.split('\t')[1].strip()
                count_str = line.split('\t')[-1].strip().replace(" ", '')
                pinyin_list = getBasicPinyin(keyword)
                if len(pinyin_list) == 0:
                    new_file.write(line)
                    new_file.flush()
                else:
                    for currPinyin in pinyin_list:
                        newLine = line.replace(pinyin_old, currPinyin)
                        new_file.write(newLine)
                        new_file.flush()
            else:
                new_file.write(line)
                new_file.flush()
        new_file.close()
def helpPinyin(pinyinList, pinyins, currPinyin, step, index, firstPinyin):
    if index != 0:
        firstPinyin *= 1000;
    if step == len(pinyinList):
        ele = list()
        for curr in currPinyin:
            ele.append(curr)
        pinyins.append(ele)
        return
    for curr_index in range(len(pinyinList[step])):
        currPinyin.append(pinyinList[step][curr_index])
        helpPinyin(pinyinList, pinyins, currPinyin, step + 1, curr_index, firstPinyin)
        currPinyin.pop()

def generatePinyins(keyword):
    #pinyinList = pinyin(keyword, style=Style.NORMAL, heteronym=True)
    pinyins = list()
    try:
        pinyinList = getPinyin(keyword)
        currPinyin = list()
        firstPinyin = 1
        for curr_index in range(len(pinyinList[0])):
            currPinyin.append(pinyinList[0][curr_index])
            helpPinyin(pinyinList, pinyins, currPinyin, 1, curr_index, firstPinyin)
            currPinyin.pop()
    except Exception as e:
        print(keyword)
        print(e)
    return pinyins
# 对所有的词组进行多音字拆分，然后重组
# 首先如果所有的都是命中第一个多音字的话那就是保持最高的频率，然后以10的倍数依次下降
def fixesBigDictErrorsWithMultiplePinyin():
    path = './Clover四叶草拼音'
    new_path = './Clover四叶草拼音new'
    
    if not os.path.exists(new_path):
        os.mkdir(f'{new_path}')
    for file_now in os.listdir(path):
        new_file_path = os.path.join(new_path, file_now)
        curr_path = os.path.join(path, file_now)
        new_file = open(new_file_path, 'w', encoding="utf-8")
        for line in open(curr_path, encoding='utf-8'):
            if "base" in curr_path:
                new_file.write(line)
                new_file.flush()
            elif "\t" in line:
                keyword = line.split('\t')[0]
                pinyin_old = line.split('\t')[1].strip()
                count_str = line.split('\t')[-1].strip().replace(" ", '')

                pinyinList = generatePinyins(keyword)
                #print(keyword)
                for currPinyinList in pinyinList:
                    currPinyin = " ".join(currPinyinList[0])
                    currCount = int(int(count_str) / int(currPinyinList[1]))
                    #print(currPinyinList)
                    #print(currCount)
                    if currCount == 0:
                        currCount = 1
                    currCountStr = str(currCount)
                    newLine = line.replace(pinyin_old, currPinyin).replace(count_str, currCountStr)
                    new_file.write(newLine)
                    new_file.flush()
            else:
                new_file.write(line)
                new_file.flush()
        new_file.close()

# 修复大字典的拼音错误
def fixesBigDictErrors():
    path = './Clover四叶草拼音'
    new_path = './Clover四叶草拼音new'
    
    if not os.path.exists(new_path):
        os.mkdir(f'{new_path}')
    for file_now in os.listdir(path):
        new_file_path = os.path.join(new_path, file_now)
        curr_path = os.path.join(path, file_now)
        new_file = open(new_file_path, 'w', encoding="utf-8")
        for line in open(curr_path, encoding='utf-8'):
            if "base" in curr_path:
                new_file.write(line)
                new_file.flush()
            elif "\t" in line:
                keyword = line.split('\t')[0]
                pinyin_old = line.split('\t')[1].strip()
                count_str = line.split('\t')[-1].strip().replace(" ", '')
                pinyin_list = generatePinyins(keyword)
                #print(pinyin_list)
                if len(pinyin_list) == 0:
                    new_file.write(line)
                    new_file.flush()
                else:
                    for pinyin in pinyin_list:
                        currPinyin = " ".join(pinyin)
                        newLine = line.replace(pinyin_old, currPinyin)
                        new_file.write(newLine)
                        new_file.flush()
            else:
                new_file.write(line)
                new_file.flush()
        new_file.close()



if __name__ == "__main__":
    #generateNewBaseDict()
    #generatePinyins("马鞍珠点弹")
    fixesBigDictErrors()
