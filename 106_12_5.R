install.packages("arules")
library(arules)
install.packages("arulesViz")
library(arulesViz)

#讀取交易資料(交易資料與一般data frame不同,為每次買了甚麼商品)
groceries = read.transactions("C:\\Users\\user\\Desktop\\groceries.csv",sep=",")
#exploring data
summary(groceries)


#看前面五筆資料
inspect(groceries[1:5])
#以head的寫法
head(groceries)
inspect(head(groceries, 5))


#觀測資料的商品購買有幾項
size(groceries[1:5])
#head取前6筆資料
size(head(groceries)) 


# itemFrequency可列出每一項品項佔的比例
itemFrequency(groceries)

#顯示三個品項的frequency
itemFrequency(groceries[,1:3])
#sort as item's name not the top three 


#用itemFrequencyPlot繪出產品佔的比例圖，support參數是僅列出此比例的項目，
#如不使用則會列出所有產品品項
itemFrequencyPlot(groceries,topN = 10)
itemFrequencyPlot(groceries,topN = 10,type = "absolute")
itemFrequencyPlot(groceries,topN = 10,horiz = T,
                  main = "Item Frequency",xlab = "Relative Frequency")

itemFrequencyPlot(groceries,support = 0.1,
                  main = "Item Frequency with S = 0.1",ylab = "Relative Frequency")


#關聯規則

apriori(groceries)

rule1 = apriori(groceries,parameter = list(support = 0.006,confidence = 0.3))
rule1
summary(rule1)

#lhs=>rhs : 買左邊也會買右邊
inspect(rule1[1:5])

#只取2個有效數字
options(digits = 2)
inspect(rule1[1:5])

#用lift排序(lift的數據是呈現一個產品和另一個產品可能被同時購買的機率)
inspect(sort(rule1,by = "lift")[1:5])
#用confidence排序
inspect(sort(rule1,by="confidence")[1:5])



#用yogurt這個產品來產生一個相關聯的rules
#找商品名稱有 "yog"的(%pin%)
yogurtr1 = subset(rule1,items %pin% "yog")
summary(yogurtr1)
inspect(yogurtr1[1:15])

#找商品名稱有 "yogurt"或"berries"的 (%in%->或)
yogr2 = subset(rule1,items %in% c("yogurt","berries"))
summary(yogr2)
inspect(yogr2[1:15])


#找商品名稱有 "yogurt"或"berries"的 (%ain%->且)
yogr3 = subset(rule1,items %ain% c("yogurt","berries"))
summary(yogr3)
inspect(yogr3)

#v效果同yogr1 但是要打商品全名
yogr4 = subset(rule1,items %ain% c("yogurt"))
summary(yogr4)
inspect(yogr4)

#視覺化
plot(rule1)
#以support,lift為方法且用confidence進行上色(shading)
plot(rule1, measure=c("support","lift"), shading="confidence")
#只畫前20個
first20 = sort(rule1,by = "lift")[1:20]
plot(first20)

#graph方法畫圖
#size越大代表support越高, color越深代表lift越高
plot(rule1[1:20], method = "graph")

#grouped方法畫圖
plot(rule1[1:20], method = "grouped")

#將rules從value轉換成data.frame格式
rule1_df = as(rule1,"data.frame")
