#階層式分群

head(iris)

#由於分群屬於「非監督式學習」的演算法，
#因此我們先把iris內的品種(Species)欄位拿掉，以剩下的資料進行分群：

data=iris[,-5]    # 移除Species(因為我們要預測這個欄位)
head(data)

#在階層式分群中，主要是以資料之間的「距離」遠近，來決定兩筆資料是否接近。
#R的話，我們可以使用dist()，來建立資料之間的「距離矩陣」(Distance Matrix)，判斷資料之間的遠與近。

E.dist=dist(data,method="euclidean")
M.dist=dist(data,method="manhattan")

#接下來，我們就可以根據資料間的距離，來進行階層式分群，使用的函式是hclust()：
par(mfrow=c(1,2))

# 使用歐式距離進行分群
h.E.cluster=hclust(E.dist)

# 使用曼哈頓距離進行分群
plot(h.E.cluster,xlab="歐式距離")

h.M.cluster=hclust(M.dist)
plot(h.M.cluster,xlab="曼哈頓距離")

#當我們有了「距離矩陣」後，要如何把資料結合起來，不同的方法也會產生不同的效果。
hclust(E.dist,method="single")      # 最近法
hclust(E.dist,method="complete")    # 最遠法
hclust(E.dist,method="average")     # 平均法
hclust(E.dist,method="centroid")    # 中心法
hclust(E.dist,method="ward.D2")     # 華德法

#用歐式距離搭配華德法，來進行階層式分群：
E.dist=dist(data,method="euclidean")   # 歐式距離
h.cluster=hclust(E.dist,method="ward.D2")  # 華德法
plot(h.cluster)
abline(h=9,col="red")


#可以觀察最佳的分群數目是3個
#利用cutree()，讓整個階層的結構縮減，變成分成三群的狀態

cut.h.cluster=cutree(h.cluster,k=3)
cut.h.cluster

# 分群結果和實際結果比較
# setosa=第1群;versicolor=第2群;virginica=第三群
#可以發現第三群分的不太好
table(cut.h.cluster,iris$Species)

#切割式分群
#使用kmeans
kmeans.cluster=kmeans(data,centers=3)   # 分成三群
kmeans.cluster$withinss # 群內的變異數


table(kmeans.cluster$cluster,iris$Species)  # 分群結果和實際結果比較
plot(data,col=kmeans.cluster$cluster)  
# 視覺化 k-means 分群結果
require(factoextra)
fviz_cluster(kmeans.cluster,
             data=data,
             geom=c("point","text"),
             frame.type="norm")












