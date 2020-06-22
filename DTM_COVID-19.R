# to connect web
install.packages(c("RCurl", "XML"))
library(RCurl) 
library(XML) 

t <- readLines('https://en.wikipedia.org/wiki/Coronavirus_disease_2019')
d <- htmlParse(t, asText = TRUE)
clean_doc <- xpathSApply(d,"//p", xmlValue)
str(clean_doc)

# 전처리
install.packages(c("tm", "SnowballC"))
# 데이터 마이닝 함수 제공
library(tm)
library(NLP)
# 어간을 추출하는 함수 제공
library(SnowballC)

#tm_map 함수는 지정된 매개변수 값에 따라 전처리 수행
doc <- Corpus(VectorSource(clean_doc))
inspect(doc)
doc <- tm_map(doc, content_transformer(tolower))
doc <- tm_map(doc, removeNumbers) 
doc <- tm_map(doc, removeWords, stopwords('english')) 
doc <- tm_map(doc, removePunctuation) 
doc <- tm_map(doc, stripWhitespace) 

# DTM 
dtm = DocumentTermMatrix(doc)
dim(dtm) 
inspect(dtm) 

#wordcloud그리기
install.packages("wordcloud")
library(RColorBrewer)
library(wordcloud)

# DTM을 행렬 표현으로 변환
m <- as.matrix(dtm) 
# 빈도(중요도)가 높은 순서로 단어를 정렬
v <- sort(colSums(m), decreasing = TRUE) 
d <- data.frame(word = names(v), freq = v)
#중요도가 높은 상위 50개만 그리기, 세로로 배치할 단어의 비율을 35%로 
wordcloud(words = d$word, freq = d$freq, min.freq = 1, max.words = 50, random.order = FALSE, rot.per = 0.35)

# RColorBrewer 라이브러리를 이용해 색상 입히기
library(RColorBrewer)
pal <- brewer.pal(11, "Spectral")
wordcloud(words = d$word, freq=d$freq, min.freq = 1, max.words = 50, random.order = FALSE, rot.per = 0.50, colors = pal)
# 폰트 변경
wordcloud(words = d$word, freq = d$freq, min.freq = 1, max.words = 50, random.order= FALSE, rot.per = 0.50, colors=pal, family="mono", font=2)


# wordcloud2
install.packages("wordcloud2")
library(wordcloud2)
wordcloud2(d)
d1 <- d[1:200, ] 
wordcloud2(d1, shape='star')
wordcloud2(d1, minRotation = pi/4, maxRotation = pi/4, rotateRatio = 1.0)
