package com.chris.modules.sys.controller;

import java.util.List;
import java.util.Map;

import com.chris.common.utils.*;
import com.chris.modules.sys.service.SysDictItemService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.chris.modules.sys.entity.SysDictEntity;
import com.chris.modules.sys.service.SysDictService;


/**
 * 字典表
 * 
 * @author chris
 * @email 258321511@qq.com
 * @since Mar 22.18
 */
@RestController
@RequestMapping("/sys/sysdict")
public class SysDictController {
	@Autowired
	private SysDictService sysDictService;

	@Autowired
	private SysDictItemService sysDictItemService;

	/**
	 * 列表
	 */
	@RequestMapping("/list")
	@RequiresPermissions("sys:sysdict:list")
	public R list(@RequestParam Map<String, Object> params){
		//查询列表数据
        Query query = new Query(params);

		List<SysDictEntity> sysDictList = sysDictService.queryList(query);
		int total = sysDictService.queryTotal(query);
		
		PageUtils pageUtil = new PageUtils(sysDictList, total, query.getLimit(), query.getPage());
		
		return R.ok().put("page", pageUtil);
	}
	
	
	/**
	 * 信息
	 */
	@RequestMapping("/info/{dictId}")
	@RequiresPermissions("sys:sysdict:info")
	public R info(@PathVariable("dictId") Integer dictId){
		SysDictEntity sysDict = sysDictService.queryObject(dictId);

		return R.ok().put("sysDict", sysDict);
	}

	@RequestMapping("/checkDictName")
	public boolean checkDictName(@RequestBody SysDictEntity sysDict){
		List<SysDictEntity> sysDictList = this.sysDictService.querySysDictListByCondition(SysDictEntity.buildByNotEqualIdAndDictName(sysDict.getDictId(), sysDict.getDictName()));
		return ValidateUtils.isEmptyCollection(sysDictList);
	}

	@RequestMapping("/querySysDictListByCondition")
	@RequiresPermissions("sys:sysdict:list")
	public CommonResponse querySysDictListByCondition(@RequestBody SysDictEntity sysDict){
		List<SysDictEntity> sysDictList = this.sysDictService.querySysDictListByCondition(sysDict);
		return CommonResponse.getSuccessResponse().setData(sysDictList);
	}
	
	/**
	 * 保存
	 */
	@RequestMapping("/save")
	@RequiresPermissions("sys:sysdict:save")
	public R save(@RequestBody SysDictEntity sysDict){
		sysDictService.save(sysDict);
		return R.ok();
	}
	
	/**
	 * 修改
	 */
	@RequestMapping("/update")
	@RequiresPermissions("sys:sysdict:update")
	public R update(@RequestBody SysDictEntity sysDict){
		sysDictService.update(sysDict);
		return R.ok();
	}
	
	/**
	 * 删除
	 */
	@RequestMapping("/delete")
	@RequiresPermissions("sys:sysdict:delete")
	public R delete(@RequestBody Integer[] dictIds){
		sysDictService.deleteBatch(dictIds);
		
		return R.ok();
	}

	/**
	 * 验证是否可删除字典项
	 */
	@RequestMapping("/isCanDelDictItem")
	@RequiresPermissions("sys:sysdict:delete")
	public boolean isCanDelDictItem(@RequestBody Integer dictItemId){
		return this.sysDictItemService.isCanDelDictItem(dictItemId);
	}
	
}
