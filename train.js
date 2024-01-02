const { NlpManager } = require('node-nlp');

const manager = new NlpManager({ languages: ['zh'] });
// 在NLP模型值中增加例句跟意圖
manager.addDocument('zh', '介紹', 'introduction.school');
manager.addDocument('zh', '自我介紹', 'introduction.school');
manager.addDocument('zh', '介紹朝陽資訊管理系的師資', 'introduction.department.teacher');
manager.addDocument('zh', '師生人數', 'introduction.department.number');
manager.addDocument('zh', '畢業出路', 'introduction.department.graduation.work');
manager.addDocument('zh', '資管畢業門檻', 'introduction.department.graduation.limit');
manager.addDocument('zh', '朝陽資管介紹', 'introduction.department.department.department.department');
manager.addDocument('zh', '朝陽資管組', 'introduction.department.department.im');
manager.addDocument('zh', '朝陽多媒組', 'introduction.department.department.media');
manager.addDocument('zh', '資管組與多媒組的差異', 'introduction.department.department.diff');
//-------------------------------------------------------------------------------------------
manager.addDocument('zh', '我想要知道朝陽位置', 'places.school');
manager.addDocument('zh', '朝陽科技大學地址', 'places.school');
manager.addDocument('zh', '朝陽科大地址', 'places.school');
manager.addDocument('zh', '我想要知道朝陽地點', 'places.school');
manager.addDocument('zh', '你們在哪', 'places.school');
manager.addDocument('zh', '朝陽資管在哪', 'places.department.department');
manager.addDocument('zh', '我想要知道資管老師的研究室', 'places.department.teacher');
//-------------------------------------------------------------------------------------------
manager.addDocument('zh', '聯絡資管老師', 'contact.department.teacher');
manager.addDocument('zh', '資管系辦電話', 'contact.department.department');
manager.addDocument('zh', '學校電話', 'contact.school');

//將意圖轉換為文字訊息
manager.addAnswer('zh', 'introduction.school', '介紹.學校');
manager.addAnswer('zh', 'introduction.department.teacher', '介紹.系所.老師');
manager.addAnswer('zh', 'introduction.department.graduation.work', '介紹.系所.畢業出路');
manager.addAnswer('zh', 'introduction.department.graduation.limit', '介紹.系所.畢業門檻');
manager.addAnswer('zh', 'introduction.department.number', '介紹.系所.人數');
manager.addAnswer('zh', 'introduction.department.department.department', '介紹.系所');
manager.addAnswer('zh', 'introduction.department.department.im', '介紹.系所.資管');
manager.addAnswer('zh', 'introduction.department.department.media', '介紹.系所.多媒');
manager.addAnswer('zh', 'introduction.department.department.diff', '介紹.系所.系所差異');
manager.addAnswer('zh', 'places.school', '地點.學校');
manager.addAnswer('zh', 'places.department.department', '地點.系所');
manager.addAnswer('zh', 'places.department.teacher', '地點.系所.老師');
manager.addAnswer('zh', 'contact.school', '聯絡.學校');
manager.addAnswer('zh', 'contact.department.teacher', '聯絡.系所.老師');
manager.addAnswer('zh', 'contact.department.department', '聯絡.系所');

// 訓練NLP的模型，並儲存NLP模型的參數
(async () => {
    await manager.train();  //訓練模型
    manager.save('trained_model/ex1-train-intents.nlp');  //儲存模型參數
    const response = await manager.process('zh', '我想了解朝陽資管的老師'); //處理訊息
    console.log(JSON.stringify(response));  //印出處理結果
})();