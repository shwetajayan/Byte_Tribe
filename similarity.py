from flask import Flask,jsonify,request
response=''
app=Flask(__name__)

@app.route('/name',methods=['GET','POST'])
def Route():
    global response
    if request.method=='POST':
        request_data=request.data
        request_data=json.loads(request_data.decode('utf-8'))
        code=request_data['Question_ID']
        name=request_data['name']
        result={
            'Question_ID': Question_ID,
            'name': name
        }
        respone=f'Hi ${name}, in ${Question_ID}'
        return " "
    elif request.method=='GET': return "hello"
    else: return "no"

if __name__=='__main__':
    app.run(debug= True)