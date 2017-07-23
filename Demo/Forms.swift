//
//  Forms.swift
//  Demo
//
//  Created by 林達也 on 2017/07/23.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import AppleMusicKit

private func csv(_ value: String) -> [String] {
    return value.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
}
private func csv(_ value: String?) -> [String]? {
    return value?.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
}
private func resources(_ value: String) -> Set<ResourceType> {
    return Set(csv(value).flatMap(ResourceType.init(rawValue:)))
}
private func resources(_ value: String?) -> Set<ResourceType>? {
    guard let arr = csv(value) else { return nil }
    return Set(arr.flatMap(ResourceType.init(rawValue:)))
}
private func inputs(storefront: String = "us", id: String) -> [FormInput] {
    return [TextInput(name: "storefront", default: storefront),
            TextInput(name: "id", default: id),
            TextInput(name: "language"),
            TextInput(name: "include")]
}

private func inputs(storefront: String = "us", ids: String) -> [FormInput] {
    return [TextInput(name: "storefront", default: storefront),
            TextInput(name: "ids", default: ids),
            TextInput(name: "language"),
            TextInput(name: "include")]
}
typealias Form = APIInputFormViewController.Form

let storefrontForms = [
    Form([TextInput(name: "id", default: "jp"), TextInput(name: "language")]) { form in
        GetStorefront(id: form["id"], language: form["language"])
    },
    Form([TextInput(name: "ids", default: "jp"), TextInput(name: "language")]) { form in
        GetMultipleStorefronts(ids: csv(form["ids"]), language: form["language"])
    }]

let mediaForms = [
    Form(inputs(id: "310730204")) { form in
        GetAlbum(storefront: form["storefront"],
                 id: form["id"],
                 language: form["language"],
                 include: resources(form["include"]))
    },
    Form(inputs(id: "639032181")) { form in
        GetMusicVideo(storefront: form["storefront"],
                      id: form["id"],
                      language: form["lamguage"],
                      include: resources(form["include"]))
    },
    Form(inputs(storefront: "jp", id: "pl.7a987d29f54b4e3e9ab15906189477f7")) { form in
        GetPlaylist(storefront: form["storefront"],
                    id: form["id"],
                    language: form["lamguage"],
                    include: resources(form["include"]))
    },
    Form(inputs(id: "900032829")) { form in
        GetSong(storefront: form["storefront"],
                id: form["id"],
                language: form["lamguage"],
                include: resources(form["include"]))
    },
    Form(inputs(id: "ra.985484166")) { form in
        GetStation(storefront: form["storefront"],
                   id: form["id"],
                   language: form["lamguage"],
                   include: resources(form["include"]))
    }]

let artistForms = [
    Form(inputs(ids: "178834,462006")) { form in
        GetMultipleArtists(storefront: form["storefront"],
                           ids: csv(form["ids"]),
                           language: form["lamguage"],
                           include: resources(form["include"]))
    },
    Form(inputs(ids: "976439448,1107687517")) { form in
        GetMultipleCurators(storefront: form["storefront"],
                            ids: csv(form["ids"]),
                            language: form["lamguage"],
                            include: resources(form["include"]))
    },
    Form(inputs(ids: "976439514,976439503")) { form in
        GetMultipleActivities(storefront: form["storefront"],
                              ids: csv(form["ids"]),
                              language: form["lamguage"],
                              include: resources(form["include"]))
    },
    Form(inputs(ids: "976439526,1017168810")) { form in
        GetMultipleAppleCurators(storefront: form["storefront"],
                                 ids: csv(form["ids"]),
                                 language: form["lamguage"],
                                 include: resources(form["include"]))
    }]

let chartForms = [
    Form([TextInput(name: "storefront", default: "jp"),
          TextInput(name: "types", default: "songs,albums,music-videos"),
          TextInput(name: "language"),
          TextInput(name: "chart"),
          TextInput(name: "genre"),
          IntInput(name: "limit"),
          IntInput(name: "offset")]) { form in
            GetCharts(storefront: form["storefront"],
                      types: resources(form["types"]),
                      language: form["language"],
                      chart: form["chart"],
                      genre: form["genre"],
                      limit: form["limit"],
                      offset: form["offset"])
    }]

let searchForms = [
    Form([TextInput(name: "storefront", default: "jp"),
          TextInput(name: "term", default: ""),
          TextInput(name: "language"),
          IntInput(name: "limit"),
          IntInput(name: "offset"),
          TextInput(name: "types")]) { form in
            SearchResources(storefront: form["storefront"],
                            term: form["term"],
                            language: form["language"],
                            limit: form["limit"],
                            offset: form["offset"],
                            types: resources(form["types"]))
    },
    Form([TextInput(name: "storefront", default: "jp"),
          TextInput(name: "term", default: ""),
          TextInput(name: "language"),
          IntInput(name: "limit"),
          TextInput(name: "types")]) { form in
            GetSearchHints(storefront: form["storefront"],
                           term: form["term"],
                           language: form["language"],
                           limit: form["limit"],
                           types: resources(form["types"]))
    }]
