//
//  NewsFeedPresenter.swift
//  VKFeed
//
//  Created by Артем Хребтов on 25.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsFeedPresentationLogic {
    func presentData(response: NewsFeed.Model.Response.ResponseType)
}

class NewsFeedPresenter: NewsFeedPresentationLogic {
    weak var viewController: NewsFeedDisplayLogic?
    
    var cellLayoutCalculator: FeedCellLayoutCalculatorProtocol = FeedCellLayoutCalculator()
    
    //задаем формат даты для России
    let dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMM 'в' HH:mm"
        return dt
    }()
    
    func presentData(response: NewsFeed.Model.Response.ResponseType) {
        switch response {
        //кейс показать новостную лентк
        case .presentNewsFeed(feed: let feed, revealedPostId: let revealedPostId):
            //проходимся по всем новостям и для каждой новости заполняем данные ячеки через функцию cellViewModel
            let cells = feed.items.map { feedItem in
                cellViewModel(from: feedItem, profiles: feed.profiles, groups: feed.groups, revealedPostId: revealedPostId )
            }
            //заполняем массивом заполненных ячеек модель новостной ленты и передаем ее во вью контроллер
            let feedViewModel = FeedViewModel.init(cells: cells)
            viewController?.displayData(viewModel: .displayNewsFeed(feedViewModel: feedViewModel))
        }
    }
    //получаем новость, массив профилей и массив групп, а так же масстив постов которые надо раскрыть
    private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group], revealedPostId: [Int]) -> FeedViewModel.Cell {
        //получаем имя и аватарку автора поста в ленте
        let profile = self.profile(for: feedItem.sourseId, profiles: profiles, groups: groups)
        //преобразуем дату поста
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)
        //получаем данные о приложенных файлах в посте
        //let photoAttachment = self.photoAttachment(feedItem: feedItem)
        let photoAttachments = self.photoAttachments(feedItem: feedItem)
        //булевая переменная которая говорит о том что данный пост есть или нет в массиве постов в котором нужно показать больше текста
        let isFullSized = revealedPostId.contains { postId -> Bool in
            return postId == feedItem.postId
        }
        //получаем размеры каждого элемента новости
        let sizes = cellLayoutCalculator.sizes(postText: feedItem.text, photoAttachments: photoAttachments, isFullSize: isFullSized)
        //заполняем мадель новостной ленты полученной информацией
        return FeedViewModel.Cell.init(postId: feedItem.postId,
                                       name: profile.name,
                                       date: dateTitle,
                                       text: feedItem.text,
                                       likes: String(feedItem.likes?.count ?? 0),
                                       comments: String(feedItem.comments?.count ?? 0),
                                       shares: String(feedItem.reposts?.count ?? 0),
                                       views: String(feedItem.views?.count ?? 0),
                                       iconUrlString: profile.photo,
                                       photoAttachments: photoAttachments,
                                       sizes: sizes)
        
    }
    
    //по sourseId понимаем от кого данный пост, от группы или пользователя
    private func profile(for sourseId: Int, profiles: [Profile], groups: [Group]) -> ProfileRep {
        let profilesOrGroups: [ProfileRep] = sourseId >= 0 ? profiles : groups
        let normalSourseId = sourseId >= 0 ? sourseId : -sourseId
        let profileRep = profilesOrGroups.first { myProfile -> Bool in
            myProfile.id == normalSourseId
        }
        return profileRep!
    }
    //берем данные приложения к новости (первое фото) и передаем все его параметры
    private func photoAttachment(feedItem: FeedItem) -> FeedViewModel.FeedCellPhotoAttachment? {
        guard let photos = feedItem.attachments?.compactMap({ attachment in
            attachment.photo
        }), let firstPhoto = photos.first else { return nil }
        return FeedViewModel.FeedCellPhotoAttachment.init(photoUrlString: firstPhoto.srcBig,
                                                          height: firstPhoto.height,
                                                          width: firstPhoto.width)
    }
    
    private func photoAttachments(feedItem: FeedItem) -> [FeedViewModel.FeedCellPhotoAttachment]{
        guard let attachments = feedItem.attachments else { return [] }
        
        return attachments.compactMap { attachment in
            guard let photo = attachment.photo else { return nil }
            return FeedViewModel.FeedCellPhotoAttachment.init(photoUrlString: photo.srcBig, height: photo.height, width: photo.width)
        }
    }
}
