package Data;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import Lib.Network;


public class UsetList
{
	/******************************
	 * メンバ変数
	*******************************/
	private Map<String, UserData> user = Collections.synchronizedMap(new HashMap<String, UserData>());
	
	/******************************
	 * ユーザデータを取得
	*******************************/
	public Map<String, UserData> get()
	{
		return user;
	}
	
	/******************************
	 * ユーザデータを取得
	*******************************/
	public UserData get(String id)
	{
		return user.get(id);
	}
	
	/******************************
	 * ユーザデータを追加
	*******************************/
	public void add(String id, Network network)
	{
		UserData ud = new UserData();
		ud.network = network;

		user.put(id, ud);
	}
	
	/******************************
	 * ユーザデータが存在するか
	*******************************/
	public boolean checkID(String id)
	{
		if (user.containsKey(id))
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	/******************************
	 * ユーザデータを消す
	*******************************/
	public void remove(String id)
	{
		user.remove(id);
	}
	
	/******************************
	 * MAP同期
	*******************************
	public void synck(String id)
	{
		UserData ud = Data.user.get(id);

		for (Map.Entry<String, UserData> e : user.entrySet()) 
		{
			ud.SynckList.add(e.getKey());
		}
	}
	*/
}
